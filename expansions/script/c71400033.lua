--蚀异梦物-铁管
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMING_SPSUMMON+TIMING_SUMMON,0)
	e1:SetCountLimit(1,71400033+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(71400033,0))
	e1:SetTarget(c71400033.target)
	e1:SetCondition(yume.YumeCon)
	e1:SetOperation(c71400033.operation)
	c:RegisterEffect(e1)
	yume.AddYumeWeaponGlobal(c)
end
function c71400033.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c71400033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c71400033.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c71400033.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c71400033.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if fc and yume.YumeCheckFilter(fc) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,fc,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c71400033.limit(g:GetFirst()))
	end
end
function c71400033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetTurnPlayer()~=tp then
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-1500)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc and yume.YumeCheckFilter(fc) then
			Duel.SendtoDeck(fc,nil,2,REASON_EFFECT)
		end
	end
--[[
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
--]]
end
function c71400033.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end