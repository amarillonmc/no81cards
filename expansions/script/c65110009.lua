--魔界女王 莉莉丝
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	local e10=e1:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetLabelObject(e10)
	c:RegisterEffect(e1)
	c:RegisterEffect(e10)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.tdcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.tdcheck(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) and Duel.GetFlagEffect(tc:GetControler(),id)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,65110000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local oe2=oe:GetLabelObject():Clone()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
		sg:AddCard(c)
		if sg:GetCount()==2 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 and g:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local sc=g:GetFirst()
			if g:GetCount()>1 then sc=g:Select(tp,1,1,nil):GetFirst() end
			local seq=c:GetSequence()
			local etype=oe1:GetType()
			local con=oe1:GetCondition()
			if not con then con=aux.TRUE end
			oe1:SetCondition(s.chcon(con,seq))
			oe1:SetType(etype|EFFECT_TYPE_XMATERIAL)
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				oe1:SetRange(LOCATION_SZONE)
			end
			c:RegisterEffect(oe1)
			local re=Effect.CreateEffect(c)
			re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			re:SetRange(0xff)
			re:SetCode(EVENT_ADJUST)
			re:SetLabelObject(oe1)
			re:SetOperation(s.resetop)
			c:RegisterEffect(re)
			if etype&EFFECT_TYPE_GRANT==0 and oe2 then
				local etype2=oe2:GetType()
				local con2=oe2:GetCondition()
				if not con2 then con2=aux.TRUE end
				oe2:SetCondition(s.chcon(con2,seq))
				oe2:SetType(etype|EFFECT_TYPE_XMATERIAL)
				if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
					oe2:SetRange(LOCATION_SZONE)
				end
				c:RegisterEffect(oe2)
				local re=Effect.CreateEffect(c)
				re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				re:SetRange(0xff)
				re:SetCode(EVENT_ADJUST)
				re:SetLabelObject(oe2)
				re:SetOperation(s.resetop)
				c:RegisterEffect(re)
			end
			Duel.Overlay(sc,c)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
			if tg:GetCount()>0 then
				Duel.HintSelection(tg)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
end
function s.chcon(con,seq)
	return function(e,tp,...)
				if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return false end
				return con(e,tp,...)
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end