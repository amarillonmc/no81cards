--电脑童
--Brilliant Program & Genius Kid || Programma Brillante & Bambino Geniale
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id,o=GetID()
function s.initial_effect(c)
	--[[(Quick Effect): You can send this card from your hand or field to the GY; reveal 1 monster in your Extra Deck, then banish it face-down, and if you do, choose up to 2 of the below values. For the rest of this turn, the chosen values of all face-up monster on the field become the respective original values of the monster banished by this card's effect.
	● ATK
	● DEF
	● Type
	● Attribute.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND|LOCATION_MZONE)
	e1:SetHintTiming(0,RELEVANT_TIMINGS)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--FILTERS E1
function s.rmfilter(c,tp)
	return not c:IsPublic() and c:IsMonster() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
--E1
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_EXTRA,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_CONFIRM,false,tp,s.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		local atk,def,type,attr = tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalRace(),tc:GetOriginalAttribute()
		local hasdef = not tc:IsType(TYPE_LINK)
		Duel.BreakEffect()
		if Duel.Banish(g,POS_FACEDOWN)>0 then
			local val=0
			for i=1,2 do
				local b1 = val&0x1==0
				local b2 = val&0x2==0 and hasdef
				local b3 = val&0x4==0
				local b4 = val&0x8==0
				local opt=aux.Option(tp,id,1,b1,b2,b3,b4)
				val = val|(2^opt)
			end
			if val~=0 then
				local c=e:GetHandler()
				if val&0x1==0x1 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(0,EFFECT_FLAG2_WICKED)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
					e1:SetValue(atk)
					e1:SetReset(RESET_PHASE|PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
				if val&0x2==0x2 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(0,EFFECT_FLAG2_WICKED)
					e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
					e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
					e1:SetValue(def)
					e1:SetReset(RESET_PHASE|PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
				if val&0x4==0x4 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CHANGE_RACE)
					e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
					e1:SetValue(type)
					e1:SetReset(RESET_PHASE|PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
				if val&0x8==0x8 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
					e1:SetValue(attr)
					e1:SetReset(RESET_PHASE|PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
end