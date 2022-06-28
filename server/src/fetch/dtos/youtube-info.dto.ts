
export class YoutubeInfo {
    constructor(
        public uploader: string,
        public title: string,
        public description: string,
        public thumbnailRAW: number[],
        public keywords: string[],
        public views: number,
        public duration: string,
        public published: string,
        public youtubeLink: string,
    ) { }
}