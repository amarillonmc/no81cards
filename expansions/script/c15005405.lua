local m=15005405
local cm=_G["c"..m]
cm.name="龙衣视界"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005397)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.drcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,m))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_TOKEN)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xaf3c) and tc:IsAbleToRemove() and Duel.IsPlayerCanSpecialSummonMonster(tp,15005397,nil,TYPES_TOKEN_MONSTER,tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalLevel(),RACE_DRAGON,tc:GetOriginalAttribute()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then

		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		local lv=tc:GetOriginalLevel()
		local attr=tc:GetOriginalAttribute()
		local tkm=0
		if attr&ATTRIBUTE_LIGHT==ATTRIBUTE_LIGHT then tkm=15005401 end
		if attr&ATTRIBUTE_DARK==ATTRIBUTE_DARK then tkm=15005391 end
		if attr&ATTRIBUTE_EARTH==ATTRIBUTE_EARTH then tkm=15005397 end
		if attr&ATTRIBUTE_WATER==ATTRIBUTE_WATER then tkm=15005395 end
		if attr&ATTRIBUTE_FIRE==ATTRIBUTE_FIRE then tkm=15005393 end
		if attr&ATTRIBUTE_WIND==ATTRIBUTE_WIND then tkm=15005399 end
		if attr&ATTRIBUTE_DIVINE==ATTRIBUTE_DIVINE then tkm=15005402 end
		local token=Duel.CreateToken(tp,tkm)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(attr)
			token:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(lv)
			token:RegisterEffect(e4)
		end
		Duel.SpecialSummonComplete()
		tc:SetCardTarget(token)

			end
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end