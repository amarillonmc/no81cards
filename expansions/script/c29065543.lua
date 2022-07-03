--方舟骑士-菲亚梅塔
c29065543.named_with_Arknight=1
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
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c29065543.atlimit) 
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(99)
	c:RegisterEffect(e3)
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
function c29065543.atlimit(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c)
end