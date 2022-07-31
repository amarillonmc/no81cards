local m=31400121
local cm=_G["c"..m]
cm.name="辉姬之五问"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.immcon)
	e5:SetValue(cm.efilter_m)
	e5:SetLabel(16)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e5:SetValue(cm.efilter_st)
	e5:SetLabel(8)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetCondition(cm.immcon)
	e7:SetLabel(4)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function cm.spcostfilter_tuner(c)
	return c:IsType(TYPE_TUNER) and c:IsLevel(7)
end
function cm.spcostfilter_ntuner(c)
	return c:IsLevel(0)
end
function cm.spcostfilter_group(g,tp,c)
	local num_tuner=g:FilterCount(cm.spcostfilter_tuner,nil)
	local num_ntuner=g:FilterCount(cm.spcostfilter_ntuner,nil)
	return #g==5 and num_tuner==1 and num_ntuner==4 and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.spcostfilter_group,5,nil,tp,c) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,nil)
	local sg=g:SelectSubGroup(tp,cm.spcostfilter_group,false,5)
	local label=0
	local xyzg=sg:Filter(Card.IsType,nil,TYPE_XYZ)
	if xyzg:GetClassCount(Card.GetRank)==#xyzg and #xyzg>0 then label=label+1 end
	local linkg=sg:Filter(Card.IsType,nil,TYPE_LINK)
	if linkg:GetClassCount(Card.GetLink)==#linkg and #linkg>0 then label=label+2 end
	if sg:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=0 then label=label+4 end
	if sg:FilterCount(Card.IsType,nil,TYPE_EFFECT)~=0 then label=label+8 end
	if sg:FilterCount(Card.IsType,nil,TYPE_EFFECT)~=#sg then label=label+16 end
	e:SetLabel(label)
	c:SetMaterial(sg)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp~=tp and bit.band(e:GetLabelObject():GetLabel(),1)~=0 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and bit.band(e:GetLabelObject():GetLabel(),2)~=0 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.immcon(e)
	return bit.band(e:GetLabelObject():GetLabel(),e:GetLabel())~=0 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.efilter_m(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function cm.efilter_st(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end