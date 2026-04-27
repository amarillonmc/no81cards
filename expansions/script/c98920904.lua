--龙剑士 技辉星·灵摆
--龙剑士·灵摆
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Pendulum Effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	--Cannot be used as material for non-Dragon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(s.matlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	--Grant effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(s.efcon)
	e5:SetOperation(s.efop)
	c:RegisterEffect(e5)
end
--Pendulum Effect
function s.penfilter(c)
	return c:IsSetCard(0xc7) or c:IsSetCard(0xda)
end
function s.ccsfilter(c)
	return c:IsSetCard(0xc7) or c:IsSetCard(0xda)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ccsfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=sg:GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)>0 then
			if sc:IsType(TYPE_XYZ) and og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_EXTRA)>0 
				and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local mg=og:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_GRAVE+LOCATION_EXTRA)
				if mg:GetCount()>0 then
					Duel.Overlay(sc,mg)
				end
			end
		end
	end
end

--Monster Effect: Material Limit
function s.matlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_DRAGON)
end

function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return r&(REASON_RITUAL+REASON_FUSION+REASON_SYNCHRO+REASON_XYZ)~=0 
		and rc:IsFaceup() and (rc:IsSetCard(0xc7) or rc:IsSetCard(0xda))
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--赋予的效果
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	--注册一个不入连锁的Flag标记，持续到当前回合结束，用于判定是否是特殊召唤回合
	rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	--检查自身是否有刚刚赋予的Flag标记，如果有则说明是特殊召唤的回合
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
