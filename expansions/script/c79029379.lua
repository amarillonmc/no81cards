--萨尔贡·医疗干员-图耶
function c79029379.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029379.splimit)
	c:RegisterEffect(e2)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029378,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029379)
	e2:SetCost(c79029379.spcost)
	e2:SetTarget(c79029379.sptg)
	e2:SetOperation(c79029379.spop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--pz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029379,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,09029379)
	e4:SetCost(c79029379.pzcost)
	e4:SetTarget(c79029379.pztg)
	e4:SetOperation(c79029379.pzop)
	c:RegisterEffect(e4)
	--ex p
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c79029379.expcost)
	e5:SetOperation(c79029379.expop)
	c:RegisterEffect(e5)
end
function c79029379.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029379.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xa900)
end
function c79029379.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local flag=Duel.GetFlagEffectLabel(tp,79029379)
	if flag then
	Duel.SetFlagEffectLabel(tp,79029379,Duel.GetTurnCount(tp)-1)
	else
	Duel.RegisterFlagEffect(tp,79029379,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2,Duel.GetTurnCount(tp))
	end
end
function c79029379.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029379.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c79029379.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("路线合理，装备正常，出发。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,3))
	local g=Duel.GetMatchingGroup(c79029379.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if Duel.GetFlagEffectLabel(tp,79029379)~=Duel.GetTurnCount(tp)-1 and Duel.IsExistingMatchingCard(c79029379.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029379,0)) then
	Debug.Message("很好，效率将会提升17%。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,4))
	local tc=Duel.SelectMatchingCard(tp,c79029379.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029379.rlfil(c)
	return c:IsSetCard(0xa900) and c:IsReleasable() 
end
function c79029379.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029379.rlfil,tp,LOCATION_MZONE,0,1,nil) end
	local flag=Duel.GetFlagEffectLabel(tp,09029379)
	if flag then
	Duel.SetFlagEffectLabel(tp,09029379,Duel.GetTurnCount(tp)-1)
	else
	Duel.RegisterFlagEffect(tp,09029379,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2,Duel.GetTurnCount(tp))
	end
	local rg=Duel.SelectMatchingCard(tp,c79029379.rlfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(rg,REASON_COST)
end 
function c79029379.pzfil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c79029379.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c79029379.pzfil,tp,LOCATION_DECK,0,1,nil) end
end
function c79029379.thfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHand()
end
function c79029379.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Debug.Message("带队作战和当向导差别不大。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,5))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c79029379.pzfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	if Duel.GetFlagEffectLabel(tp,09029379)~=Duel.GetTurnCount(tp)-1 and Duel.IsExistingMatchingCard(c79029379.thfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029379,1)) then
	Debug.Message("得快些行动了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,6))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local xc=Duel.SelectMatchingCard(tp,c79029379.thfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoHand(xc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,xc)
	Duel.Recover(tp,xc:GetAttack(),REASON_EFFECT)
	end
	end
end
function c79029379.expcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2500) end
	local flag=Duel.GetFlagEffectLabel(tp,19029379)
	if flag then
	Duel.SetFlagEffectLabel(tp,19029379,Duel.GetTurnCount(tp)-1)
	else
	Duel.RegisterFlagEffect(tp,19029379,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2,Duel.GetTurnCount(tp))
	end
	Duel.PayLPCost(tp,2500)
end
function c79029379.ppfil(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and lv>lsc and lv<rsc 
end
function c79029379.expop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("风的味道变了......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,7))
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c79029379.pendvalue)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if Duel.GetFlagEffectLabel(tp,19029379)~=Duel.GetTurnCount(tp)-1 and Duel.IsExistingMatchingCard(c79029379.ppfil,tp,LOCATION_DECK,0,1,nil,e,tp,lsc,rsc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029379,0)) then
	Debug.Message("再快一些。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029379,8))
	local tc=Duel.SelectMatchingCard(tp,c79029379.ppfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,lsc,rsc)
	Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029379.pendvalue(e,c)
	return c:IsSetCard(0xa900)
end




