--水特效
function c33718012.initial_effect(c)
	
--你控制的「水之女演员 / Aquaactress」怪兽被送入墓地的场合，可以从墓地·牌组将1体ATK·DEF和低于该怪兽的「水之女演员 / Aquaactress」怪兽特殊召唤，从牌组特殊召唤的场合，
--你受到等同于那体怪兽ATK·DEF之和的伤害。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33718012.condition)
	e1:SetTarget(c33718012.target)
	e1:SetOperation(c33718012.operation)
	c:RegisterEffect(e1)
--这张卡从场上送去墓地的场合，以自己墓地1只水族怪兽为对象才能发动。那只怪兽特殊召唤。
--这个效果的发动后，直到回合结束时自己不是水族怪兽不能特殊召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c33718012.spcondition)
	e2:SetTarget(c33718012.sptarget)
	e2:SetOperation(c33718012.spoperation)
	c:RegisterEffect(e2)
end
function c33718012.filter(c)
	return c:IsSetCard(0xcd) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c33718012.condition(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabel(eg:GetFirst():GetAttack()+eg:GetFirst():GetDefense())
	return eg:IsExists(c33718012.filter,1,nil,tp)
end
function c33718012.damagefilter(c,e,tp)
	local sum=e:GetLabel()
	return c:IsSetCard(0xcd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttack()+c:GetDefense()<=sum
end
function c33718012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33718012.damagefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33718012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33718012.damagefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		if g:GetFirst():IsPreviousLocation(LOCATION_DECK) then
			local atk=tc:GetBaseAttack()
			local def=tc:GetBaseDefense()
			Duel.Damage(tp,atk+def,REASON_EFFECT)
		end
	end
end

function c33718012.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33718012.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718012.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718012.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33718012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33718012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33718012.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33718012.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33718012.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_AQUA
end