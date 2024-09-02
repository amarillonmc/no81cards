--幽魂科学家 索菲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--damval
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	local e10=e1:Clone()
	e10:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e10:SetCondition(s.damcon)
	e1:SetLabelObject(e10)
	c:RegisterEffect(e1)
	c:RegisterEffect(e10)
	--spssummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:GetFlagEffect(id)==0 then
		Duel.Hint(HINT_CARD,0,id)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function s.damcon(e)
	return e:GetHandler():GetFlagEffect(id)==0
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSummonableCard()
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp) end
	if chk==0 then
		return c:IsCanOverlay() and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)		 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local oe2=oe:GetLabelObject():Clone()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
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
		local re=Effect.CreateEffect(c)
		re:SetRange(0xff)
		re:SetCode(EVENT_ADJUST)
		re:SetLabelObject(oe)
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