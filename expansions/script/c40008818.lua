--影贵勋-吸血鬼·拜伦
function c40008818.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,c40008818.ovfilter,aux.Stringid(40008818,0),99)
	c:EnableReviveLimit()   
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40008818.sslimit)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008818,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c40008818.tgcost)
	e2:SetTarget(c40008818.tgtg)
	e2:SetOperation(c40008818.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008818,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40008818.cost)
	e3:SetTarget(c40008818.sptg)
	e3:SetOperation(c40008818.spop)
	c:RegisterEffect(e3)
end
function c40008818.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:GetOverlayGroup():IsExists(c40008818.matfil,1,nil)
end
function c40008818.matfil(c)
	local tp=c:GetControler()
	return c:GetOwner()~=1-tp and c:IsType(TYPE_MONSTER)
end
function c40008818.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_ZOMBIE)
end
function c40008818.cfilter(c)
	return c:IsSetCard(0x8e) and c:IsAbleToGraveAsCost()
end
function c40008818.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008818.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40008818.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c40008818.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:GetBaseAttack()>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
	end
end
function c40008818.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008818.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(1-tp) 
		and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c40008818.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c40008818.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
end
function c40008818.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=nil
	local g=eg:Filter(c40008818.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	if g:GetCount()==1 then
		sg=g
	else
		sg=g:Select(tp,1,1,nil)
	end
   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local tc=Duel.GetOperatedGroup():GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetValue(0x8e)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e1,tp)
	Duel.SpecialSummonComplete()
end