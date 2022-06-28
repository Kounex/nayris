
export class SongData {
  constructor(
    public artist: string,
    public title: string,
    public album: string,
    public year: string,
    public coverRAW: number[],
    public youtubeLink: string,
  ) { }
}