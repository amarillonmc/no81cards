--方舟骑士-菲亚梅塔
function c29065543.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--spsummon   
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c29065543.sprcon)
	e0:SetOperation(c29065543.sprop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29065543.splimit)
	c:RegisterEffect(e1)
	--Destroy  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)
	e1:SetTarget(c29065543.dstg)
	e1:SetOperation(c29065543.dsop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29065543.atkcon1)
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c29065543.atkcon2)
	c:RegisterEffect(e3)  
	--def 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29065543,0))
	e4:SetCategory(EFFECT_UPDATE_DEFENSE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetTarget(c29065543.ddtg)
	e4:SetOperation(c29065543.ddop)
	c:RegisterEffect(e4)  
end
function c29065543.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.synlimit(e,se,sp,st)
end
function c29065543.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,3,REASON_COST) 
end
function c29065543.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x10ae,3,REASON_COST)
end
function c29065543.dsfil(c,e,tp) 
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c29065543.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()>0 and Duel.IsExistingMatchingCard(c29065543.dsfil,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end 
	local g=Duel.GetMatchingGroup(c29065543.dsfil,tp,0,LOCATION_ONFIELD,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),nil,0)
end
function c29065543.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c29065543.dsfil,tp,0,LOCATION_ONFIELD,nil,e,tp)   
	if g:GetCount()>0 then 
	Duel.Destroy(g,REASON_EFFECT)
	end
end
function c29065543.atkcon1(e)
	return e:GetHandler():GetBaseDefense()>=700
end
function c29065543.atkcon2(e)
	return e:GetHandler():GetBaseDefense()>=1100
end
function c29065543.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c29065543.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	local def=c:GetBaseDefense()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(def-400)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end
end










