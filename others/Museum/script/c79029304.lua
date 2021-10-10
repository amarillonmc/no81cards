--个人行动·理智崩坏
function c79029304.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c79029304.accost)
	e1:SetTarget(c79029304.actg)
	e1:SetOperation(c79029304.acop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029304.attg)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c79029304.atop)
	c:RegisterEffect(e3)
end
function c79029304.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp end
	Duel.Recover(1-tp,eg:Filter(Card.IsControlerCanBeChanged,nil):GetSum(Card.GetAttack),REASON_COST)
end
function c79029304.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(Card.IsControlerCanBeChanged,nil)~=0 end
	Duel.SetTargetCard(eg:Filter(Card.IsControlerCanBeChanged,nil))
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg:Filter(Card.IsControlerCanBeChanged,nil),eg:Filter(Card.IsControlerCanBeChanged,nil):GetCount(),tp,0)
end
function c79029304.acop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("这是一张多么可爱的睡脸啊，让我真想就这样——")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029304,1))
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.GetControl(g,tp)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029093) and Duel.SelectYesNo(tp,aux.Stringid(79029304,0)) then
	e:GetHandler():CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c79029304.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(1-tp,ACTIVITY_ATTACK)==0 and Duel.GetTurnPlayer()~=tp end
end
function c79029304.atop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("嗯~抱歉喽。不过，这就是我为你们准备好的结局哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029304,2))
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029093)   then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c79029304.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e1,tp)
	end
end
function c79029304.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end 








