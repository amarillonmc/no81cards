--失 落 帝 国 的 创 造 主  玛 丽  · 苏
local m=22348392
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22348392.spcon)
	e1:SetOperation(c22348392.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22348392.gecon1)
	e2:SetValue(c22348392.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348392.gecon2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c22348392.gecon3)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c22348392.gecon4)
	e6:SetValue(2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetDescription(aux.Stringid(22348392,4))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1)
	e7:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c22348392.gecon5)
	e7:SetTarget(c22348392.remtg)
	e7:SetOperation(c22348392.remop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DRAW)
	e8:SetDescription(aux.Stringid(22348392,5))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1)
	e8:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c22348392.gecon6)
	e8:SetTarget(c22348392.drtg)
	e8:SetOperation(c22348392.drop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(22348392,6))
	e9:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c22348392.gecon7)
	e9:SetTarget(c22348392.distg)
	e9:SetOperation(c22348392.disop)
	c:RegisterEffect(e9)
end
function c22348392.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22348392.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22348392.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348392.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22348392.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c22348392.remop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c22348392.atkval(e,c)
	return e:GetHandler():GetMaterialCount()*1200
end
function c22348392.gecon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348392)>0
end
function c22348392.gecon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348393)>0
end
function c22348392.gecon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348394)>0
end
function c22348392.gecon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348395)>0
end
function c22348392.gecon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348396)>0
end
function c22348392.gecon6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348397)>0
end
function c22348392.gecon7(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(22348398)>0
end
function c22348392.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22348392.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local count=g:GetClassCount(Card.GetAttribute)
	while count>0 do
	local off=1
	local ops={}
	local opval={}
	local off2=1
	local ops2={}
	local opval2={}
	if not c:GetFlagEffectLabel(22348392) then
		ops[off]=aux.Stringid(22348392,0)
		opval[off-1]=1
		off=off+1
	end
	if not c:GetFlagEffectLabel(22348393) then
		ops[off]=aux.Stringid(22348392,1)
		opval[off-1]=2
		off=off+1
	end
	if not c:GetFlagEffectLabel(22348394) then
		ops[off]=aux.Stringid(22348392,2)
		opval[off-1]=3
		off=off+1
	end
	if not c:GetFlagEffectLabel(22348395) or not c:GetFlagEffectLabel(22348396) or not c:GetFlagEffectLabel(22348397) or not c:GetFlagEffectLabel(22348398) then
		ops[off]=aux.Stringid(22348392,7)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		c:RegisterFlagEffect(22348392,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,0))
	elseif sel==2 then
		c:RegisterFlagEffect(22348393,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,1))
	elseif sel==3 then
		c:RegisterFlagEffect(22348394,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,2))
	elseif sel==4 then
		if not c:GetFlagEffectLabel(22348395) then
			ops2[off2]=aux.Stringid(22348392,3)
			opval2[off2-1]=1
			off2=off2+1
		end
		if not c:GetFlagEffectLabel(22348396) then
			ops2[off2]=aux.Stringid(22348392,4)
			opval2[off2-1]=2
			off2=off2+1
		end
		if not c:GetFlagEffectLabel(22348397) then
			ops2[off2]=aux.Stringid(22348392,5)
			opval2[off2-1]=3
			off2=off2+1
		end
		if not c:GetFlagEffectLabel(22348398) then
			ops2[off2]=aux.Stringid(22348392,6)
			opval2[off2-1]=4
			off2=off2+1
		end
		local op2=Duel.SelectOption(tp,table.unpack(ops2))
		local sel2=opval2[op2]
		if sel2==1 then
			c:RegisterFlagEffect(22348395,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,3))
		elseif sel2==2 then
			c:RegisterFlagEffect(22348396,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,4))
		elseif sel2==3 then
			c:RegisterFlagEffect(22348397,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,5))
		elseif sel2==4 then
			c:RegisterFlagEffect(22348398,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(22348392,6))
		end
	end
		count=count-1
	end
end