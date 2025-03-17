--方舟骑士团-博士
local m=29065502
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065502,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29065502)
	e1:SetCost(c29065502.drcost)
	e1:SetTarget(c29065502.drtg)
	e1:SetOperation(c29065502.drop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065502,5))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c29065502.rmcon)
	e2:SetTarget(c29065502.rmtg)
	e2:SetOperation(c29065502.rmop)
	c:RegisterEffect(e2)
	
end
function c29065502.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return ep==tp and Duel.GetAttackTarget()==nil
end
function c29065502.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return tc:IsAbleToRemove(1-tp,POS_FACEDOWN,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c29065502.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,1-tp)
	end
end
function c29065502.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c29065502.amyfilter(c)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065502.spfilter(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065502.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or (Duel.IsExistingMatchingCard(c29065502.amyfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29065502.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	if Duel.IsExistingMatchingCard(c29065502.amyfilter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetLabel(100)
		if not Duel.IsPlayerCanDraw(tp,1) then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		end
	else
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c29065502.spfilter2(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065502.drop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(29065502,2)
		opval[off-1]=1
		off=off+1
	end
	if e:GetLabel()==100 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29065502.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(29065502,3)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(c29065502.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
			if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29065502,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29065502.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
