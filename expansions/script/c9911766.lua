--归航的宝札
function c9911766.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9911766.cost)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911766,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9911766.drcon)
	e2:SetCost(c9911766.drcost)
	e2:SetTarget(c9911766.drtg)
	e2:SetOperation(c9911766.drop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
end
function c9911766.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(9911766,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(9911767,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		e:GetLabelObject():GetLabelObject():AddCard(tc)
	end
end
function c9911766.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function c9911766.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911766.cfilter,1,nil,tp)
end
function c9911766.rmfilter(c,fid)
	return c:GetFlagEffectLabel(9911767)==fid and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c9911766.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fid=0
	local g=e:GetLabelObject()
	if c:GetFlagEffect(9911766)~=0 then
		fid=c:GetFlagEffectLabel(9911766)
	else
		e:GetLabelObject():DeleteGroup()
	end
	if chk==0 then return g and g:IsExists(c9911766.rmfilter,1,nil,fid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:FilterSelect(tp,c9911766.rmfilter,1,1,nil,fid)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c9911766.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9911766.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
