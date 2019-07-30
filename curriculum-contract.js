/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');
const Aux = require('./aux.js');
const fs = require('fs');

class curriculumContract extends Contract {

    async curriculumExists(ctx, cpf) {
        const buffer = await ctx.stub.getState(cpf);
        return (!!buffer && buffer.length > 0);
    }

    async createcurriculum(ctx, cpf, alumnName) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (exists) {
            throw new Error(`The curriculum ${cpf} already exists`);
        }
        const asset = {
            cpf: cpf,
            name: alumnName,
            library: []
        };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(cpf, buffer);
    }

    async readcurriculum(ctx, cpf) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (!exists) {
            throw new Error(`The curriculum ${cpf} does not exist`);
        }
        const buffer = await ctx.stub.getState(cpf);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    async updatecurriculum(ctx, cpf, alumnName) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (!exists) {
            throw new Error(`The curriculum ${cpf} does not exist`);
        }
        var curriculum = await ctx.stub.getState(cpf);
        curriculum = JSON.parse(curriculum);
        const asset = { 
            cpf: cpf,
            name: alumnName,
            library: curriculum.library
        };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(cpf, buffer);
    }

    async deletecurriculum(ctx, cpf) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (!exists) {
            throw new Error(`The curriculum ${cpf} does not exist`);
        }
        await ctx.stub.deleteState(cpf);
    }

    async createCourse(ctx, cpf, courseName) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (!exists) {
            throw new Error(`The curriculum ${cpf} does not exist`);
        }
        var curriculum = await ctx.stub.getState(cpf);
        curriculum = JSON.parse(curriculum);
        const course = {
            course: courseName,
            skill: [] 
        };
        curriculum.library.push(course);
        const buffer = Buffer.from(JSON.stringify(curriculum));
        await ctx.stub.putState(cpf, buffer);
    }

    async readcurriculumHistory(ctx, cpf) {
        const exists = await this.curriculumExists(ctx, cpf);
        if (!exists) {
            throw new Error(`The curriculum ${cpf} does not exist`);
        }
        const history = await ctx.stub.getHistoryForKey(cpf);
        const curriculumHistory = history !== undefined ? await Aux.iteratorForJSON(history, true) : [];
        const stringcurriculumHistory = JSON.stringify(curriculumHistory);
        fs.writeFile('history.json', stringcurriculumHistory, err => {
            if (err) console.error(err);
            console.log('History CREATED!');
        });
        return {
            status: 'Ok',
            history: stringcurriculumHistory
        }
    }

}

module.exports = curriculumContract;
