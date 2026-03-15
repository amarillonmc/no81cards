-- 终烬圣界
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.immop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f51) and c:IsLevelAbove(1)
end

function s.desfilter(c)
	return c:IsSetCard(0x5f51)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.lvfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,99,nil)	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,#g,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if #tg==0 then return end
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(12)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end	
	Duel.AdjustInstantly() 
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,#tg,#tg,c)   
	if #dg>0 then
		local conf=dg:Filter(Card.IsFacedown,nil)
		if #conf>0 then Duel.ConfirmCards(1-tp,conf) end
		local count = Duel.Destroy(dg,REASON_EFFECT)		
		if count > 0 then
			local sc=Duel.GetMatchingGroup(function(xyzc)
				return xyzc:IsSetCard(0x5f51) and xyzc:IsType(TYPE_XYZ) 
					and xyzc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)			end,tp,LOCATION_EXTRA,0,nil)
			if #sc>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=sc:Select(tp,1,1,nil):GetFirst()
				local mg=Duel.GetMatchingGroup(function(mc)
					return mc:IsFaceup() and mc:IsType(TYPE_MONSTER) and mc:IsCanBeXyzMaterial(xyz)			   end,tp,LOCATION_MZONE,0,nil)
				if #mg>=2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local mat=mg:FilterSelect(tp,function(mc) return mc:IsLevel(12) end,2,64,nil)
					if #mat>=2 then
						xyz:SetMaterial(mat)
						Duel.Overlay(xyz,mat)
						if Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then						   xyz:CompleteProcedure()
						end
					end
				end
			end
		end
	end
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f51))
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te)
	local owner=te:GetOwner()
	return owner:IsSetCard(0x5f51) and owner:IsType(TYPE_MONSTER) 
		and owner:IsControler(1-e:GetHandlerPlayer()) and owner:IsLocation(LOCATION_MZONE)
end