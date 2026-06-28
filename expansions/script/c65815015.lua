--任务：T4-雅各布基地
--效果：
--①：自己场上有「起义军领袖 雷诺」或「克哈之子 蒙斯克」的场合才能发动。从自己卡组·墓地把1张装备卡加入手卡。那之后，自己场上有「起义呐喊」怪兽的场合，可以选场上1张卡送去墓地。
local s,id,o=GetID()
-- TODO: 请将以下ID替换为实际的自定义卡片ID
-- RENO_ID = 起义军领袖 雷诺 的卡号
-- MENGSIKE_ID = 克哈之子 蒙斯克 的卡号
-- UPRISING_SETCODE = 「起义呐喊」的系列编号 (如0x1234)
local RENO_ID=65814080
local MENGSIKE_ID=65814090
local UPRISING_SETCODE=0x6a31
function s.initial_effect(c)
	aux.AddCodeList(c,RENO_ID,MENGSIKE_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(RENO_ID) or c:IsCode(MENGSIKE_ID))
end
function s.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.ufilter(c)
	return c:IsFaceup() and c:IsSetCard(UPRISING_SETCODE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if not Duel.IsExistingMatchingCard(s.ufilter,tp,LOCATION_MZONE,0,1,nil) then return end
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
