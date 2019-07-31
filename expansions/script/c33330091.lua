--芳晓佳节的贺礼
function c33330091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c33330091.condition)
	e1:SetTarget(c33330091.target)
	e1:SetOperation(c33330091.activate)
	c:RegisterEffect(e1)	
end
function c33330091.condition(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c33330091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return #g>0 and g:GetFirst():IsAbleToRemove() end
	local ct=0
	if #g==1 then
		ct=1
	else
		ct=Duel.AnnounceNumber(tp,1,2)
	end
	local rg=Duel.GetDecktopGroup(1-tp,ct)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function c33330091.activate(e,tp)
	local ct=e:GetLabel()
	local rg=Duel.GetDecktopGroup(1-tp,ct)   
	local rct=Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	if rct<=0 then return end
	local g=Duel.GetOperatedGroup()
	if rct>1 and Duel.IsPlayerCanDraw(tp,rct) and Duel.SelectYesNo(tp,aux.Stringid(33330091,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(33330091,RESET_EVENT+RESETS_STANDARD,0,0,fid)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(c33330091.thcon)
	e1:SetOperation(c33330091.thop)
	g:KeepAlive()
	e1:SetLabelObject(g)	
	e1:SetLabel(fid)
	e1:SetValue(Duel.GetTurnCount())
	Duel.RegisterEffect(e1,tp)
end
function c33330091.thfilter(c,fid)
	return c:GetFlagEffectLabel(33330091)==fid
end
function c33330091.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c33330091.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnCount()~=e:GetValue() end
end
function c33330091.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33330091)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33330091.thfilter,nil,e:GetLabel())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	g:DeleteGroup()
	e:Reset()
end
