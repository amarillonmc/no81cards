--封缄的策士 优特雷
function c67200287.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--release replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_RELEASE_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c67200287.reptg)
	e1:SetValue(c67200287.repval)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67200287+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c67200287.spcon)
	e2:SetOperation(c67200287.spop)
	--e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,67200287+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c67200287.spcon2)
	e3:SetOperation(c67200287.spop2)	
	c:RegisterEffect(e3) 
	--Equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200287,5))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,67200288)
	e4:SetTarget(c67200287.eqtg)
	e4:SetOperation(c67200287.eqop)
	c:RegisterEffect(e4) 
end
--
function c67200287.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x674)
end
function c67200287.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c67200287.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(67200287,1)) then
		Duel.SendtoExtraP(c,tp,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c67200287.repval(e,c)
	return c67200287.repfilter(c,e:GetHandlerPlayer())
end
--
function c67200287.rfilter(c,tp)
	--local tp=c:GetControler()
	return c:IsFaceup() and c:IsSetCard(0x674) and c:IsReleasable() 
end

function c67200287.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end

function c67200287.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c67200287.rfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then 
		return Duel.IsExistingMatchingCard(c67200287.rfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) 
	else
		return rg:GetCount()>1 and rg:IsExists(c67200287.mfilter,1,nil,tp)
	end
end

function c67200287.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c67200287.rfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c67200287.mfilter,1,1,nil,tp)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	end
	Duel.Release(g,REASON_COST)
end
--
function c67200287.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0 and c:IsSetCard(0x674) and c:IsReleasable() and c:IsFaceup()
end
function c67200287.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200287.spfilter2,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c67200287.spfilter2,1,nil,tp,g)
end
function c67200287.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c67200287.spfilter2,tp,LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c67200287.spfilter2,1,1,nil,tp,g)

	Duel.Release(g1,REASON_COST)
end
--
function c67200287.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x674)
end
function c67200287.eqfilter(c)
	return c:IsSetCard(0x674) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) and not c:IsForbidden()
end
function c67200287.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200287.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67200287.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200287.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,c67200287.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c67200287.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200287.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_EQUIP_LIMIT)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetLabelObject(tc)
			e4:SetValue(c67200287.eqlimit)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e4)
		end
	end
end
function c67200287.eqlimit(e,c)
	return c==e:GetLabelObject()
end

