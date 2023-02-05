--空隙制衡者 审判官
local m=30008804
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.grecon1)
	e3:SetOperation(cm.greop)
	c:RegisterEffect(e3)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_REMOVE)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCondition(cm.grecon2)
	e12:SetOperation(cm.greop)
	c:RegisterEffect(e12)
	cm.gap_machine_remove_effect=e12
end
--special summon rule
function cm.f(c,tp)
	local trchk=c:IsFaceup() or c:IsControler(tp)
	local rechk=c:IsLevelAbove(9) or c:IsRankAbove(9)
	local mtchk=c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
	return trchk and rechk and mtchk 
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(cm.f,nil,tp)
	return g:CheckSubGroup(aux.mzctcheckrel,2,2,tp)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(cm.f,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheckrel,false,2,2,tp)
	Duel.Release(sg,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	e1:SetReset(RESET_EVENT+0xec0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:CompleteProcedure()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if ev==nil then return end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local chk1=re:IsHasCategory(CATEGORY_REMOVE)
	local chk2=ex1 and (dv1&LOCATION_REMOVED==LOCATION_REMOVED or (g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED)))
	local chk3=ex2 and (dv2&LOCATION_REMOVED==LOCATION_REMOVED or (g2 and g2:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED)))
	if rp==1-tp and (chk1 or chk2 or chk3) then
		Duel.Hint(HINT_CARD,0,m) 
		Duel.NegateEffect(ev)
	end
end
--Effect 1
function cm.grecon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and rp==1-tp
end
function cm.grecon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()~=LOCATION_ONFIELD and rp==1-tp and c:IsPreviousControler(tp) 
end
function cm.greop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_REMOVE)  
	e1:SetCondition(cm.rtcon)
	e1:SetOperation(cm.rtop)
	e1:SetLabel(Duel.GetTurnCount()+1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.rf(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.rf,1,nil)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tag=eg:Filter(cm.rf,nil)
	local thg=tag:Filter(Card.IsAbleToHand,nil,tp)
	if #thg==0 then return end
	local xg=Group.CreateGroup()
	for tc in aux.Next(thg) do
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			xg:AddCard(tc)
			tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(m,1))  
		end 
	end  
	Duel.ConfirmCards(1-tp,xg) 
	xg:KeepAlive()
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END) 
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.tthcon)
	e12:SetOperation(cm.tthop)
	e12:SetLabel(e:GetLabel())
	e12:SetLabelObject(xg)
	e12:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e12,tp)
end
function cm.ctf(c,tp)
	local chk=c:IsLocation(LOCATION_EXTRA) and c:GetOwner()==1-tp
	return c:GetFlagEffect(m+100)>0 and (c:IsLocation(LOCATION_HAND) or chk)
end
function cm.ccf(c,tp)
	return c:GetFlagEffect(m+100)>0 and c:IsLocation(LOCATION_EXTRA) and c:GetOwner()==1-tp
end
function cm.tthcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g==0 then return false end
	local tg=g:Filter(cm.ctf,nil,e:GetHandlerPlayer())
	return Duel.GetTurnCount()==e:GetLabel() and #g>0 and #tg>0
end
function cm.tthop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.ctf,nil,e:GetHandlerPlayer())
	if #tg==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	local pc=e:GetHandlerPlayer()
	local exg=Duel.GetMatchingGroup(cm.ccf,tp,LOCATION_EXTRA,0,nil,pc)
	if #exg>0 then
		Duel.SendtoGrave(exg,REASON_RULE)
		Duel.SendtoDeck(exg,1-pc,SEQ_DECKSHUFFLE,REASON_EFFECT)
		tg:Sub(exg)
	end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end