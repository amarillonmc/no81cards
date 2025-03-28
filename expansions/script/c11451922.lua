--波动变换·射频滤波器
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2(c))
	e2:SetOperation(cm.spop2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(cm.sptg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(function() return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)<Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil) end)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(function() return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil) end)
	Duel.RegisterEffect(e2,tp)
end
function cm.sptg(e,c)
	if not c:IsType(TYPE_MONSTER) or c:IsHasEffect(EFFECT_REVIVE_LIMIT) or c:IsLevelBelow(1) then return false end
	local eset={c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
	for _,te in pairs(eset) do
		if te:GetOwner()==c and (te:GetValue()==0 or te:GetValue()==aux.FALSE) then return false end
	end
	return true
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local num=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return Duel.GetMZoneCount(tp)>0 and (num%c:GetLevel())==0 and num~=0 --and Duel.GetDecktopGroup(tp,c:GetLevel()//2):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==c:GetLevel()//2
end
function cm.sptg2(sc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:SelectSubGroup(tp,function(g) return g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,m),1,nil) end,Duel.IsSummonCancelable(),c:GetLevel()//2,c:GetLevel()//2)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(sg,REASON_RETURN)
end