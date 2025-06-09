--佐天泪子
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x23c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		--cannot activate until damaged or equipped
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_PHASE+RESETS_STANDARD)
		Duel.RegisterEffect(e1,tp)
		--change scale
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LSCALE)
		e2:SetValue(0)
		e2:SetCondition(s.sccon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e3)
		--check damage
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_DAMAGE)
		e4:SetOperation(s.checkop)
		e4:SetLabelObject(e1)
		e4:SetReset(RESET_PHASE+RESETS_STANDARD)
		Duel.RegisterEffect(e4,tp)
		--check equip
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_EQUIP)
		e5:SetOperation(s.checkop2)
		e5:SetLabelObject(e1)
		e5:SetReset(RESET_PHASE+RESETS_STANDARD)
		Duel.RegisterEffect(e5,tp)
	end
end
function s.sccon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.aclimit(e,re,tp)
	return re:GetHandler()==e:GetLabelObject()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		e:GetLabelObject():Reset()
		e:GetHandler():ResetFlagEffect(id)
		e:Reset()
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local eq=eg:GetFirst()
	if not eq then return end
	local tc=eq:GetEquipTarget()
	if tc:IsControler(tp) then
		e:GetLabelObject():Reset()
		e:GetHandler():ResetFlagEffect(id)
		e:Reset()
	end
end

--aux.Stringid(id,0)对应"手卡1只「超炮」怪兽特殊召唤"
