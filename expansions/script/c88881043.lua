--地狱海龙神-利维坦
function c88881043.initial_effect(c)
	aux.AddCodeList(c,22702055)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e0:SetCost(c88881043.sumcost)
	e0:SetTarget(c88881043.sumtg)
	e0:SetOperation(c88881043.sumop)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881043)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e1:SetTarget(c88881043.thtg)
	e1:SetOperation(c88881043.thop)
	c:RegisterEffect(e1)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c88881043.spcon)
	e3:SetOperation(c88881043.adjustop)
	c:RegisterEffect(e3)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c88881043.spcon)
	e4:SetTarget(c88881043.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetCondition(c88881043.con)
	e7:SetValue(c88881043.aclimit)
	c:RegisterEffect(e7)
	--  
	local e8=Effect.CreateEffect(c)  
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c88881043.op)  
	c:RegisterEffect(e8) 
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)   
end
function c88881043.op(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("游戏结束了‧‧‧‧‧‧")
	Debug.Message("在深海的地狱中感受永恒吧‧‧‧‧‧‧")
end
function c88881043.con(e,c)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
end
function c88881043.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c88881043.thfilter(c)
	return (c:IsCode(22702055) or c:IsSetCard(0x177,0x178) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function c88881043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88881043.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88881043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88881043.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88881043.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function c88881043.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(false,nil) or e:GetHandler():IsMSetable(false,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c88881043.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=c:IsSummonable(false,nil)
	local s2=c:IsMSetable(false,nil)
	if (s1 and s2 and Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
		Duel.Summon(tp,c,false,nil)
	elseif s2 then
		Duel.MSet(tp,c,false,nil)
	end
end
function c88881043.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22702055) 
end
function c88881043.rmfilter(c)
	return c:IsFaceup()
end
function c88881043.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumtype==SUMMON_TYPE_DUAL then return false end
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c88881043.rmfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c88881043.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_ONFIELD,0,nil)
	local rc=g:GetCount()
	if rc>1 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local dg=g:Select(1-tp,rc-1,rc-1,nil)
		sg:Merge(dg)
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end