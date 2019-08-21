--融合测试伞
local m=1141021
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Tatara=true
--
function c1141021.initial_effect(c)
--
	c:EnableReviveLimit()  
	aux.AddFusionProcMix(c,true,true,c1141021.FusFilter1,c1141021.FusFilter2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1141021,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c1141021.tg1)
	e1:SetOperation(c1141021.op1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetOperation(c1141021.op3)
	c:RegisterEffect(e3)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1141021,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1141021.cost2)
	e2:SetTarget(c1141021.tg2)
	e2:SetOperation(c1141021.op2)
	c:RegisterEffect(e2)
--
end
--
function c1141021.FusFilter1(c)
	return muxu.check_fusion_set_Tatara(c)
end
function c1141021.FusFilter2(c)
	local p=c:GetControler()
	return c:IsFusionType(TYPE_FLIP)
		or (Duel.GetFlagEffect(p,1141002)>0 and c:IsFacedown())
end
--
c1141021.muxu_mat_count=2
c1141021.muxu_ih_KTatara=1
--
function c1141021.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_MZONE,1,nil) end
	if e:GetHandler():GetFlagEffect(1141021)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(1141021)
	else
		e:SetLabel(0)
	end
	local sg=Group.CreateGroup()
	if e:GetLabel()==1 then
		sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	else
		sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1141021.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	if e:GetLabel() and e:GetLabel()==1 then
		sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	else
		sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	end
	if sg:GetCount()<1 then return end
	Duel.Destroy(sg,REASON_EFFECT)
end
--
function c1141021.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
--
function c1141021.tfilter2(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c1141021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1141021.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1141021.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c1141021.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--
function c1141021.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsPosition(POS_FACEUP_DEFENSE) then return end
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)<1 then return end
	if not muxu.check_set_Tatara(tc) then return end
	if not c:IsType(TYPE_FUSION) then return end
	if not c:IsType(TYPE_MONSTER) then return end
	tc:CopyEffect(c:GetCode(),RESET_EVENT+0x1fe0000)
end
--
function c1141021.op3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1141021,0,0,0)
end
--
