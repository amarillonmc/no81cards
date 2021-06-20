--邪神魔兽 格里姆德
local m=25000159
local cm=_G["c"..m]
function cm.initial_effect(c)
 --pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter1)
	c:RegisterEffect(e2)
--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.con4)
	e4:SetValue(cm.actlimit)
	c:RegisterEffect(e4)
 --
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end

function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)   
end
function cm.cfilter2(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=eg:Filter(cm.cfilter2,nil)
	return eg:IsExists(cm.cfilter,1,nil) and tg:CheckWithSumGreater(Card.GetLevel,12) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	   e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)  end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not  e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tg=eg:Filter(cm.cfilter2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local  mat=tg:SelectWithSumGreater(tp,Card.GetLevel,12)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT)
	c:SetMaterial(nil)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	c:CompleteProcedure()
end

function cm.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.filter(c,tp)
	return not c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetControler()==1-tp
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end

function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>=10000
end
function cm.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAttack()>=1000 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not c:IsFaceup() or not c:IsRelateToEffect(e) or c:GetAttack()<1000
		 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local atk=c:GetAttack()
	local max=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local t={}
	local l=1
	while l<=max and l*1000<=atk  do
		t[l]=l*1000
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local anatk=Duel.AnnounceNumber(tp,table.unpack(t))
	local ss=anatk/1000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-anatk)
	c:RegisterEffect(e1)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ss,ss,nil)
	if dg:GetCount()>0 then
	   Duel.HintSelection(dg)
	   Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end