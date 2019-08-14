--空想的轮回
function c10122012.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122012,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10122012.target)
	e1:SetOperation(c10122012.operation)
	c:RegisterEffect(e1)	  
end
function c10122012.dhfilter(c)
	return c:IsSetCard(0xc333) and c:IsDiscardable()
end
function c10122012.thfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToHand() and not c:IsCode(10122012)
end
function c10122012.refilter(c)
	return c:IsCode(10122011) and c:IsReleasableByEffect()
end
function c10122012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10122012.dhfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c10122012.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c10122012.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(10122012,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10122012,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10122012,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	  e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	  Duel.SetTargetPlayer(tp)
	  Duel.SetTargetParam(2)
	  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif sel==2 then
	  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
	  e:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	  Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c10122012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c10122012.dhfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c10122012.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b3=Duel.CheckReleaseGroup(tp,c10122012.refilter,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if sel==1 and b1 then 
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	   if Duel.DiscardHand(p,c10122012.dhfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		  Duel.Draw(p,d,REASON_EFFECT)
	   end
	elseif sel==2 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10122012.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif sel==3 and b3 then
		local sg=Duel.SelectReleaseGroup(tp,c10122012.refilter,1,1,nil)
		if Duel.Release(sg,REASON_EFFECT)~=0 then
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end