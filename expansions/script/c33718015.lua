--水首映
function c33718015.initial_effect(c)
--作为发动此卡的效果处理，从你的牌组将1体「水之女演员 / Aquaactress」怪兽与1张「水族馆 / Aquarium」卡加入手牌。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33718015.operation)
	c:RegisterEffect(e1)
	
--在你的战斗阶段，可以将你控制的「水族馆 / Aquarium」卡任意张送去墓地；
--在这个战斗阶段中，位于被送去墓地的卡的魔法·陷阱区域之前的怪兽区域中的「水之女演员 / Aquaactress」怪兽可以进行直接攻击。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33718015,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCondition(c33718015.battlecondition)
	e2:SetTarget(c33718015.battletarget)
	e3:SetCost(c33718015.battlecost)
	e2:SetOperation(c33718015.battleoperation)
	c:RegisterEffect(e2)
--这张卡从场上送去墓地的场合，以自己墓地1只水族怪兽为对象才能发动。
--那只怪兽特殊召唤。
--这个效果的发动后，直到回合结束时自己不是水族怪兽不能特殊召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c33718015.spcondition)
	e3:SetTarget(c33718015.sptarget)
	e3:SetOperation(c33718015.spoperation)
	c:RegisterEffect(e3)
end
function c33718015.filter1(c)
	return c:IsSetCard(0xce) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c33718015.filter2,tp,LOCATION_DECK,0,1,nil)
end
function c33718015.filter2(c)
	return c:IsSetCard(0xcd) and c:IsAbleToHand()
end

function c33718015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c33718015.filter1,tp,LOCATION_DECK,0,1,nil)
	local g2=Duel.GetMatchingGroup(c33718015.filter2,tp,LOCATION_DECK,0,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33718015,0))
	then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		sg:AddCard(g2:Select(tp,1,1,nil))
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c33718015.battlecondition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c33718015.battlefilter(c)
	return c:IsControler(tp) and c:IsSetCard(0xce) and c:IsAbleToGraveAsCost()
end
function c33718015.battlecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718015.battlefilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c33718015.battlefilter,tp,LOCATION_SZONE,0,nil)
	local sg=g:Select(tp,1,g,nil)
	local sgone=sg:GetFirst()
	while sgone do 
		e:SetLabel(1<<sgone:GetSequence())
		Duel.HintSelection(sgone)
		Duel.SendtoGrave(sgone,REASON_COST)
		sgone=sg:GetNext()
	end
end
--e:label==zone1 zone2 zone3 zone4 zone5 
function c33718015.battletarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
end
--c15000625
--c15130912
function c33718015.battleopreation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33718015.ttk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabel(zone)
	Duel.RegisterEffect(e1,tp)
end
function c33718015.ttk(e,c)
	local zone=e:GetLabel()
	return c:IsFaceup() and c:GetSequence()==zone and c:IsSetCard(0xcd) 
end

function c33718015.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33718015.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718015.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718015.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33718015.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33718015.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33718015.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33718015.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33718015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_AQUA
end