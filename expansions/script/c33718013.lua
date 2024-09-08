--水替身
function c33718013.initial_effect(c)
	
--你控制的「水之女演员 / Aquaactress」怪兽被送入墓地的场合，可以从墓地将该怪兽的同名卡1张表侧攻击表示置放在你的场上，
--这个效果在场上置放的卡每个卡名每回合只能进行1次。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c33718013.condition)
	e1:SetTarget(c33718013.target)
	e1:SetOperation(c33718013.operation)
	c:RegisterEffect(e1)
--这张卡从场上送去墓地的场合，以自己墓地1只水族怪兽为对象才能发动。那只怪兽特殊召唤。
--这个效果的发动后，直到回合结束时自己不是水族怪兽不能特殊召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c33718013.spcondition)
	e2:SetTarget(c33718013.sptarget)
	e2:SetOperation(c33718013.spoperation)
	c:RegisterEffect(e2)
end
--GetOriginalCode 
function c33718013.filter(c)
	return c:IsSetCard(0xcd) and (c:IsReason(REASON_BATTLE) or c:GetReason(REASON_DESTROY)) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end 
function c33718013.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33718013.filter,1,nil,tp) and e:SetLabel(eg:GetFirst():GetOriginalCode())
end
function c33718013.limitfilter(c,e,tp)
	return c:IsCode(e:GetLabel()) c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33718013.limitfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c33718013.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33718013.limitfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetLabel(g:GetFirst():GetOriginalAttribute())
			e1:SetTarget(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function c33718013.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33718013.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718013.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718013.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33718013.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33718013.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33718013.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33718013.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33718013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_AQUA
end