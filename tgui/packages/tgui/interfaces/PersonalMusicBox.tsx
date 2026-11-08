import {
  Box,
  Button,
  Knob,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type LibraryTrack = {
  index: number;
  name: string;
  duration: string;
  current: BooleanLike;
};

type Data = {
  playing: BooleanLike;
  repeat: BooleanLike;
  has_track: BooleanLike;
  track_name: string | null;
  track_duration: string | null;
  volume: number;
  in_hand: BooleanLike;
  upload_ready: BooleanLike;
  upload_block_reason: string | null;
  play_ready: BooleanLike;
  play_block_reason: string | null;
  library: LibraryTrack[];
  uploads_max: number;
  max_file_size_mb: number;
};

export const PersonalMusicBox = () => {
  const { act, data } = useBackend<Data>();
  const {
    playing,
    repeat,
    has_track,
    track_name,
    track_duration,
    volume,
    in_hand,
    upload_ready,
    upload_block_reason,
    play_ready,
    play_block_reason,
    library,
    uploads_max,
    max_file_size_mb,
  } = data;

  return (
    <Window title="Личный проигрыватель" width={420} height={480}>
      <Window.Content scrollable>
        {!in_hand && (
          <NoticeBox>
            Возьмите проигрыватель в руки, чтобы загрузить или выбрать трек.
          </NoticeBox>
        )}
        <Section
          title="Воспроизведение"
          buttons={
            <>
              <Button.Checkbox
                icon="arrow-rotate-left"
                checked={repeat}
                disabled={!has_track || playing}
                onClick={() => act('repeat')}
              >
                Повтор
              </Button.Checkbox>
              <Button
                icon={playing ? 'stop' : 'play'}
                color={playing ? 'bad' : 'good'}
                disabled={!playing && (!has_track || !play_ready)}
                onClick={() => act('toggle')}
              >
                {playing ? 'Стоп' : 'Играть'}
              </Button>
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Трек">
              {has_track ? track_name : 'Не загружен'}
            </LabeledList.Item>
            {!!track_duration && (
              <LabeledList.Item label="Длительность">
                {track_duration}
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Статус">
              {playing ? 'Играет' : has_track ? 'Готов' : 'Ожидает трек'}
            </LabeledList.Item>
            <LabeledList.Item label="Громкость">
              <Knob
                size={1.25}
                value={volume}
                unit="%"
                minValue={0}
                maxValue={100}
                step={5}
                stepPixelSize={1}
                onChange={(e, value) => act('set_volume', { volume: value })}
              />
            </LabeledList.Item>
          </LabeledList>
          {!!has_track && !playing && !play_ready && !!play_block_reason && (
            <NoticeBox mt={1}>{play_block_reason}</NoticeBox>
          )}
        </Section>
        <Section title={`Библиотека (${library.length} из ${uploads_max})`}>
          {library.length === 0 && (
            <Box color="label">Загруженные за раунд треки появятся здесь.</Box>
          )}
          {library.map((track) => (
            <Button
              key={track.index}
              fluid
              ellipsis
              icon="music"
              selected={!!track.current}
              disabled={!in_hand || !!playing}
              onClick={() => act('select_track', { index: track.index })}
            >
              {`${track.name} (${track.duration})`}
            </Button>
          ))}
        </Section>
        <Section title="Загрузка">
          <Box mb={1}>
            Выберите файл <b>.ogg</b> или <b>.mp3</b> с компьютера (до{' '}
            {max_file_size_mb} МБ).
          </Box>
          <Button
            fluid
            icon="upload"
            disabled={!in_hand || !!playing || !upload_ready}
            onClick={() => act('upload')}
          >
            Загрузить трек
          </Button>
          {!!in_hand && !upload_ready && !!upload_block_reason && (
            <NoticeBox mt={1}>{upload_block_reason}</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
