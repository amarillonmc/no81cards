--迈德谟斯-亡国的王储-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡：基本分4000以下才能发动，自身特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.hcond)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--①墓地：基本分2000以下时，这个效果1回合也可以有1次从墓地发动
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCondition(cm.gcond)
	e1b:SetCountLimit(1,m+300)
	c:RegisterEffect(e1b)
	--②召唤·特殊召唤成功：支付一半基本分，从卡组检索记述陷阱卡，那之后可除外对方攻3000以下怪兽全部
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--③可以向对方怪兽全部各作1次攻击
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--泰坦权能「尼卡多利-天谴之矛-」：自己·对方的战斗阶段，对方不能把效果发动（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,2))
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_CANNOT_ACTIVATE)
	t1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	t1:SetRange(LOCATION_MZONE)
	t1:SetTargetRange(0,1)
	t1:SetValue(1)
	t1:SetCondition(cm.titancon)
	c:RegisterEffect(t1)
	--献予「纷争」之诗：升级版——追加对方场上的怪兽攻击力·守备力变为0
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,3))
	t2:SetCondition(cm.upcon)
	c:RegisterEffect(t2)
	local t3=Effect.CreateEffect(c)
	t3:SetDescription(aux.Stringid(m,3))
	t3:SetType(EFFECT_TYPE_FIELD)
	t3:SetCode(EFFECT_SET_ATTACK_FINAL)
	t3:SetRange(LOCATION_MZONE)
	t3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	t3:SetTarget(cm.atk0tg)
	t3:SetValue(0)
	t3:SetCondition(cm.upcon)
	c:RegisterEffect(t3)
	local t4=t3:Clone()
	t4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(t4)
end
function cm.hcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4000
end
function cm.gcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
function cm.trapfilter(c)
	return c:IsType(TYPE_TRAP) and aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,math.floor(Duel.GetLP(tp)/2)) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.trapfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rmfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000) and c:IsAbleToRemove()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--那之后，可以让对方场上攻击力是3000以下的怪兽全部除外
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
--泰坦权能
function cm.titancon(e)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_DAMAGE_CAL
end
function cm.upcon(e)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_DAMAGE_CAL
end
--升级版攻守变0：对方场上的怪兽
function cm.atk0tg(e,c)
	return c:IsControler(1-e:GetOwnerPlayer())
end
