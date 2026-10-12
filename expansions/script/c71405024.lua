--棱镜世界的管理系统-普莉兹姆
local s,id,o=GetID()
function s.initial_effect(c)
	 c:EnableReviveLimit()
	 --material
	 aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),aux.NonTuner(nil),1)
	 --banish the field face-down
	 local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(id,0))
	 e1:SetCategory(CATEGORY_REMOVE)
	 e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	 e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetCountLimit(1,id)
	 e1:SetProperty(EFFECT_FLAG_DELAY)
	 e1:SetCost(s.cost)
	 e1:SetTarget(s.tg1)
	 e1:SetOperation(s.op1)
	 c:RegisterEffect(e1)
	 --cannot activate other cards' effects
	 local e3=Effect.CreateEffect(c)
	 e3:SetType(EFFECT_TYPE_FIELD)
	 e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	 e3:SetRange(LOCATION_MZONE)
	 e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	 e3:SetTargetRange(1,0)
	 e3:SetValue(s.aclimit)
	 c:RegisterEffect(e3)
	 --negate an effect activation
	 local e4=Effect.CreateEffect(c)
	 e4:SetDescription(aux.Stringid(id,1))
	 e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	 e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	 e4:SetType(EFFECT_TYPE_QUICK_O)
	 e4:SetCode(EVENT_CHAINING)
	 e4:SetRange(LOCATION_MZONE)
	 e4:SetCountLimit(1,id+100000)
	 e4:SetCondition(s.con4)
	 e4:SetCost(s.cost)
	 e4:SetTarget(s.tg4)
	 e4:SetOperation(s.op4)
	 c:RegisterEffect(e4)
	 --negate a Normal, Flip, or Special Summon
	 local e4a=e4:Clone()
	 e4a:SetCode(EVENT_SUMMON)
	 e4a:SetCondition(aux.NegateSummonCondition)
	 e4a:SetTarget(s.tg4s)
	 e4a:SetOperation(s.op4s)
	 c:RegisterEffect(e4a)
	 local e4b=e4a:Clone()
	 e4b:SetCode(EVENT_FLIP_SUMMON)
	 c:RegisterEffect(e4b)
	 local e4c=e4a:Clone()
	 e4c:SetCode(EVENT_SPSUMMON)
	 c:RegisterEffect(e4c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	 if chk==0 then
		 return c:GetMaterial():GetCount()==0
			 or Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
	 end
	 if c:GetMaterial():GetCount()>0 then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
		 Duel.Remove(g,POS_FACEUP,REASON_COST)
	 end
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
	 local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp,POS_FACEDOWN)
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp,POS_FACEDOWN)
	 if g:GetCount()>0 then
		 Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	 end
end
function s.aclimit(e,re,tp)
	 return re:GetHandler()~=e:GetHandler()
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	 return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	 	and re and Duel.IsChainNegatable(ev)
end
function s.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return s.nbcon(tp,re) end
	 s.nbtg(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.nbcon(tp,re)
	 local rc=re:GetHandler()
	 return Duel.IsPlayerCanRemove(tp)
		 and (not rc:IsRelateToEffect(re) or rc:IsAbleToRemove(tp,POS_FACEDOWN))
end
function s.nbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return s.nbcon(tp,re) end
	 Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	 if re:GetHandler():IsRelateToEffect(re) then
		 Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	 end
	 if re:GetActivateLocation()==LOCATION_GRAVE then
		 e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	 else
		 e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	 end
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	 local rc=re:GetHandler()
	 if Duel.NegateActivation(ev) and rc and rc:IsRelateToEffect(re)
		 and rc:IsAbleToRemove(tp,POS_FACEDOWN) then
		 Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
	 end
end
function s.tg4s(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsPlayerCanRemove(tp) end
	 Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function s.op4s(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateSummon(eg)
	 Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end
