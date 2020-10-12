--罗德岛·近卫干员-史尔特尔
function c79029325.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)	
	--end ov
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79029325.edtg)
	e2:SetOperation(c79029325.edop)
	c:RegisterEffect(e2)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029325.condition)
	e2:SetTarget(c79029325.lztg)
	e2:SetOperation(c79029325.lzop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c79029325.incon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c79029325.incon)
	e4:SetValue(c79029325.efilter)
	c:RegisterEffect(e4)  
end
function c79029325.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029325.edop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
	Debug.Message("愚蠢的家伙！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029325,1))
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	if Duel.CheckLPCost(tp,4000) and Duel.SelectYesNo(tp,aux.Stringid(79029325,0)) then
	Debug.Message("没用的人都赶快撤退！这里我来。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029325,2))
	Duel.PayLPCost(tp,4000)
	else
	Debug.Message("我知道自己走。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029325,3))
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	end
end
function c79029325.xfil(c,e,tp)
	local seq=e:GetHandler():GetSequence()
	return  c:IsPreviousLocation(LOCATION_OVERLAY) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST))
end
function c79029325.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=eg:Filter(c79029325.xfil,nil,e,tp)   
	return eg:FilterCount(c79029325.xfil,nil,e,tp)>0 and (xg:IsExists(Card.IsType,1,nil,TYPE_SPELL) or (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) and xg:IsExists(Card.IsType,1,nil,TYPE_TRAP)) or (xg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)) )
end
function c79029325.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local xg=eg:Filter(c79029325.xfil,nil,e,tp)
	Debug.Message("一个也别想逃走。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029325,4))
	if xg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500*xg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500*xg:GetCount())
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) and xg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	end
end
function c79029325.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=eg:Filter(c79029325.xfil,nil,e,tp)

	if xg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then   
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) and xg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)  
	end 
	if xg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
	local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local atk=mg:GetSum(Card.GetAttack)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	end		
end
function c79029325.incon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function c79029325.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end









