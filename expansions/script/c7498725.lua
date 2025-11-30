--无敌军贯-金枪鱼级一号舰
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,24639891,7474643)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--apply the effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=0
	if c:GetMaterial():FilterCount(Card.IsCode,nil,24639891)>0 then flag=flag|1 end
	if c:GetMaterial():FilterCount(Card.IsCode,nil,7474643)>0 then flag=flag|2 end
	e:GetLabelObject():SetLabel(flag)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.thfilter(c)
	return c:IsSetCard(0x166) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	if chk==0 then return chk1 and Duel.IsPlayerCanDraw(tp,1)
		or chk2 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetCategory(0)
	if chk1 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if chk2 then
		e:SetCategory(e:GetCategory()|(CATEGORY_TOHAND+CATEGORY_SEARCH))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	if chk1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if chk2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local turn=Duel.GetTurnPlayer()
	return (turn==1-tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) or turn==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function s.ctfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsSetCard(0x166)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
