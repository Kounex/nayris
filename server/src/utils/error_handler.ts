import { HttpException, HttpStatus } from "@nestjs/common";

export enum ErrorType {
    emptySearch,
    noResult,
    convert,
}

export class ErrorHandler {
    public static httpException(errorType: ErrorType): HttpException {
        return new HttpException({ error: errorType.valueOf() }, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}