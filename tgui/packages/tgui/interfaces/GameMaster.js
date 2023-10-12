import { useBackend } from '../backend';
import { Flex, Dropdown, Button, Section } from '../components';
import { Window } from '../layouts';

export const GameMaster = (props, context) => {
  const { data, act } = useBackend(context);

  return (
    <Window width={400} height={400}>
      <Window.Content scrollable>
        <Section title="Spawning">
          <Flex grow direction="column">
            <Flex.Item>
              <Flex grow>
                <Flex.Item>
                  <Button.Input
                    fluid
                    middle
                    content="###"
                    onCommit={(e, value) => {
                      act('set_xeno_spawns', { value });
                    }}
                  />
                </Flex.Item>
                <Flex.Item grow>
                  <Dropdown
                    options={data.spawnable_xenos}
                    selected={data.default_spawnable_xeno_string}
                    onSelected={(new_xeno) => {
                      act('set_selected_xeno', { new_xeno });
                    }}
                  />
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item>
              <Flex grow>
                <Flex.Item>
                  <Button.Checkbox
                    checked={data.spawn_ai}
                    content="AI"
                    onClick={() => {
                      act('xeno_spawn_ai_toggle');
                    }}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    selected={data.spawn_click_intercept}
                    content="Click Spawn"
                    onClick={() => {
                      act('toggle_click_spawn');
                    }}
                  />
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
