--不知火的抚子
function c98920387.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920387,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920387)
	e1:SetTarget(c98920387.target)
	e1:SetOperation(c98920387.operation)
	c:RegisterEffect(e1) 
   --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920387,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98930387)
	e2:SetTarget(c98920387.damtg)
	e2:SetOperation(c98920387.damop)
	c:RegisterEffect(e2)
end
function c98920387.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsType(TYPE_TUNER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c98920387.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c98920387.filter2(c,e,tp,lv)
	return c:GetLevel()==lv  and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xd9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920387.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c98920387.filter1,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920387.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920387.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetHandler():GetLevel()) 
	local tc=g:GetFirst()
	local lv=e:GetHandler():GetLevel()+tc:GetLevel()
	local g=Group.FromCards(e:GetHandler(),tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98920387.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local pc=sg:GetFirst()
			local fid=c:GetFieldID()
			pc:RegisterFlagEffect(98920387,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(pc)
			e3:SetCondition(c98920387.rmcon)
			e3:SetOperation(c98920387.rmop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c98920387.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c98920387.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c98920387.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(98920387)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c98920387.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end