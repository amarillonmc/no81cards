--终烬圣界
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)

	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.immop)
	c:RegisterEffect(e2)
end

function s.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f51) and c:IsLevelAbove(1)
end

function s.desfilter(c)
	return c:IsSetCard(0x5f51) and c:IsDestructable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.lvfilter(chkc) end
	local ph=Duel.GetCurrentPhase()
	local is_main = (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)	
	if chk==0 then 
		return is_main 
			and Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
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
		if count == #tg then
			local mg=Duel.GetMatchingGroup(function(mc)
				return mc:IsFaceup() and mc:IsLevel(12) and mc:IsSetCard(0x5f51)
			end,tp,LOCATION_MZONE,0,nil)

			local sc=Duel.GetMatchingGroup(function(xyzc)
				return xyzc:IsSetCard(0x5f51) and xyzc:IsType(TYPE_XYZ) 
					and xyzc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
			end,tp,LOCATION_EXTRA,0,nil)
			if #sc>0 and #mg>=2 and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=sc:Select(tp,1,1,nil):GetFirst()

				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local mat=mg:Select(tp,2,64,nil)
				xyz:SetMaterial(mat)
				Duel.Overlay(xyz,mat)
				if Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
					xyz:CompleteProcedure()
				end
			end
		end
	end
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f51))
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te)
	return te:GetOwner():IsSetCard(0x5f51) and te:GetOwner():IsControler(1-e:GetHandlerPlayer())
end