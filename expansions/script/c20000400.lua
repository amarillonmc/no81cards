--机艺AF0301-01
fu_hd=fu_hd or {}
function fu_hd.AttackTrigger(c,Give)
	--这张卡的攻击宣言时
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,20000400,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(fu_hd.SpSummon(Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.BeAttackTrigger(c,Give)
	--这张卡成为攻击对象时
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,20000400,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(fu_hd.SpSummon(Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.TargetTrigger(c,Give,loc)
	--以loc(默认Mzone)的这张卡为对象的卡的效果发动时(场上,魔陷,墓地,remove)
	local code=c:GetOriginalCodeRule()
	aux.AddCodeList(c,20000400,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	if loc then e1:SetRange(loc)
	else e1:SetRange(LOCATION_MZONE) end
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(fu_hd.TargetTriggerCondtion)
	e1:SetOperation(fu_hd.SpSummon(Give))
	c:RegisterEffect(e1)
	return e1
end
function fu_hd.GiveTarget(e,c)
	return c:IsCode(20000400)
end
function fu_hd.SpInOp(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,fu_hd.SpInTgf,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function fu_hd.TargetTriggerCondtion(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(e:GetHandler()) then return false end
	return true
end
function fu_hd.Infinity(c)
	return c:IsCode(20000400) and c:IsFaceup()
end
function fu_hd.SpFilter(c,e,tp,code)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.IsExistingMatchingCard(fu_hd.Infinity,tp,LOCATION_MZONE,0,1,nil) then
		return c:IsSetCard(0xfd4) and not c:IsCode(code)
	end
	return c:IsCode(20000400)
end
function fu_hd.SpSummon(Give)
		return function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					local code=c:GetOriginalCodeRule()
					if Duel.IsExistingMatchingCard(fu_hd.SpFilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
						if c:IsFacedown() then Duel.ConfirmCards(1-c:GetControler(),c) end
						Duel.Hint(HINT_CARD,0,code)
						if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) then
							local sc=Duel.SelectMatchingCard(tp,fu_hd.SpFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
							Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
							if Give then Give(c) end
						end
					end
				end
end
--[[
if not cm then return end
function cm.initial_effect(c)
	local e1=fu_hd.Effect1(c,m,cm.Give)
end
function cm.Give(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local ph=Duel.GetCurrentPhase()
		return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end)
	e1:SetTarget(cm.GiveEffect1Target)
	e1:SetOperation(cm.GiveEffect1Operation)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(0xff)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.GiveTarget)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function cm.GiveTarget(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfd4)
end
function cm.GiveEffect1Target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.GiveEffect1TargetCheck(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.GiveEffect1TargetCheck,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,cm.GiveEffect1TargetCheck,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(cm.GiveEffectTargetChainLimit)
end
function cm.GiveEffect1TargetCheck(c)
	return c:IsOnField() and c:IsAbleToDeck()
end
function cm.GiveEffect1Operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.GiveEffectTargetChainLimit(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER) and tp==rp
end
--]]