--龙门·特种干员-孑
function c79029293.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2,c79029293.ovfilter,aux.Stringid(79029293,0))
	c:EnableReviveLimit()  
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79029293.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52792430,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetTarget(c79029293.sptg1)
	e3:SetOperation(c79029293.spop1)
	c:RegisterEffect(e3)	  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c79029293.damtg)
	e3:SetOperation(c79029293.damop)
	c:RegisterEffect(e3)
end
function c79029293.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029293.atkval(e,c)
	return c:GetOverlayCount()*2500
end
function c79029293.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
	op=0
	else 
	op=1
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,0)
	end
	e:SetLabel(op)
end
function c79029293.spop1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Debug.Message("啊，忘了收摊......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029293,1))
	else
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Debug.Message("老板，我觉得，跑路比较好。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029293,2))
	end
end
function c79029293.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,bc:GetBaseAttack())
end
function c79029293.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.Recover(tp,atk,REASON_EFFECT)
	Debug.Message("老板，这就......算完了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029293,3))
end
















