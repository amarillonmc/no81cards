--异梦奏进-神代心春
function c71402000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71402000,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c71402000.sctg)
	e1:SetOperation(c71402000.scop)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x714)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71402000,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,71402000)
	e3:SetCondition(c71402000.spcon)
	e3:SetTarget(c71402000.sptg)
	e3:SetOperation(c71402000.spop)
	c:RegisterEffect(e3)
	--dice
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71402000,2))
	e4:SetCategory(CATEGORY_DICE+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,71502000)
	e4:SetTarget(c71402000.eftg)
	e4:SetOperation(c71402000.efop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(71402000,ACTIVITY_SPSUMMON,c71402000.counterfilter)
end
c71402000.toss_dice=true
function c71402000.counterfilter(c)
	return c:IsType(TYPE_LINK) or c:IsSetCard(0x714)
end
function c71402000.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return sc and sc:GetLeftScale()<13 end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c71402000.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToChain()) or tc:GetLeftScale()>=13 then return end
	local dc=Duel.TossDice(tp,1)
	local sch=math.min(13-c:GetLeftScale(),dc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(sch)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	tc:RegisterEffect(e2)
end
function c71402000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_LINK) or c:IsSetCard(0x714))
end
function c71402000.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71402000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71402000.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c71402000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK)
end
function c71402000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71402000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c71402000.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71402000.filter2(c)
	return c:IsSetCard(0x714) and c:IsAbleToGrave()
end
function c71402000.filter3(c)
	return c:IsSetCard(0x714) and c:IsAbleToHand()
end
function c71402000.efop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then yume.ActivateYumeField(e,tp)
	elseif dc==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c71402000.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif dc==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c71402000.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	elseif dc==4 then
		local thg=Duel.GetMatchingGroup(c71402000.filter3,tp,LOCATION_GRAVE,0,nil)
		if thg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=thg:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	elseif dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif dc==6 then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
	end
end