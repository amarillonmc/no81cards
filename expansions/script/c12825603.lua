--铳影-唐莹
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825603.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3)
	c:EnableReviveLimit()
	chiki.c4a71Limit(c)
	chiki.c4a71tohand(c)
	chiki.c4a71kang(c,nil,c12825603.rmtg,c12825603.rmop,CATEGORY_REMOVE,12825603,1102,12825608)
end
function c12825603.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function c12825603.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end