--美食连结 凯露
function c10700221.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700221.lcheck)
	c:EnableReviveLimit()  
	--link
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700221.lkcon)  
	e0:SetOperation(c10700221.lkop)  
	c:RegisterEffect(e0)   
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700221,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700221)
	e1:SetCondition(c10700221.descon)
	e1:SetTarget(c10700221.destg)
	e1:SetOperation(c10700221.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c10700221.descon2)
	c:RegisterEffect(e2) 
	--Disable
	--local e3=Effect.CreateEffect(c)
   -- e3:SetCategory(CATEGORY_DISABLE)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EVENT_TO_GRAVE)
	--e3:SetCondition(c10700221.dcscon)
	--e3:SetOperation(c10700221.dcsop)
	--c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700221,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10700222)
	e4:SetTarget(c10700221.drtg)
	e4:SetOperation(c10700221.drop)
	c:RegisterEffect(e4)
end
function c10700221.lcheck(g,lc)
	return g:IsExists(c10700221.mzfilter,1,nil)
end
function c10700221.mzfilter(c)
	return c:IsLinkSetCard(0x3a01) and not c:IsLinkType(TYPE_LINK)
end
function c10700221.lkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c10700221.lkop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("成为我的仆人吧~")
	Debug.Message("我会和你一起战斗的 所以拙劣的战斗是绝不允许的哦！")
end
function c10700221.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState() and e:GetHandler():GetMutualLinkedGroupCount()==0
end
function c10700221.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Debug.Message("做好觉悟了吗？")
	Debug.Message("格林炸裂！（Grim-burst)")
end
function c10700221.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10700221.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
--function c10700221.desfilter(c,tp)
   -- return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==1-tp 
--end
--function c10700221.dcscon(e,tp,eg,ep,ev,re,r,rp)
   -- local tp=e:GetHandler():GetControler()
   -- return eg:IsExists(c10700221.desfilter,1,nil,tp)
--end
--function c10700221.dcsop(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetHandler()
	--local tp=e:GetHandler():GetControler()
	--local g=eg:Filter(c10700221.desfilter,nil,tp)
	--if g:GetCount()==0 then return end
	--local tc=g:GetFirst()
	--while tc do
	   -- local e1=Effect.CreateEffect(c)
	   -- e1:SetType(EFFECT_TYPE_FIELD)
	   -- e1:SetCode(EFFECT_DISABLE)
	   -- e1:SetTargetRange(0xff,0xff)
	   -- e1:SetTarget(c10700221.distg)
		--e1:SetLabelObject(tc)
	   -- e1:SetReset(RESET_PHASE+PHASE_END)
	   -- Duel.RegisterEffect(e1,tp)
	   -- local e3=Effect.CreateEffect(c)
	   -- e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   -- e3:SetCode(EVENT_CHAIN_SOLVING)
	   -- e3:SetCondition(c10700221.discon)
	  --  e3:SetOperation(c10700221.disop)
	  --  e3:SetLabelObject(tc)
	  --  e3:SetReset(RESET_PHASE+PHASE_END)
	  --  Duel.RegisterEffect(e3,tp)
	  --  tc=g:GetNext()
   -- end
--end
--function c10700221.distg(e,c)
	--local tc=e:GetLabelObject()
	--return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
--end
--function c10700221.discon(e,tp,eg,ep,ev,re,r,rp)
	--local tc=e:GetLabelObject()
	--return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
--end
--function c10700221.disop(e,tp,eg,ep,ev,re,r,rp)
   -- Duel.NegateEffect(ev)
--end
function c10700221.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700221.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end