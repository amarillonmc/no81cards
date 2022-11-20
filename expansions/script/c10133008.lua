--Blood Marker
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.A_NegateActivation(c,"dum",{1,id,"o"},rscon.neg("s,t,m",1),
		rscost.cost({s.cfilter,s.gcheck},"res",LOCATION_MZONE,0,1,2),
		"des,rec",nil,s.tg,s.act)
end
function s.cfilter1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334)
end
function s.cfilter(c)
	return (s.cfilter1(c) or c:IsCode(10133001)) and c:IsReleasable()
end
function s.gcheck(g,e,tp)
	if #g == 2 then 
		return g:IsExists(Card.IsCode,2,nil,10133001)
	else
		return g:IsExists(s.cfilter1,1,nil)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local lp = math.floor(Duel.GetLP(1-tp) / 2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lp)
end
function s.act(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 1 then
		if rsop.SelectOperate("des",tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,{}) > 0 then
			local lp = math.floor(Duel.GetLP(1-tp) / 2)
			Duel.SetLP(1-tp,lp)
			Duel.Recover(tp,lp,REASON_EFFECT)
			return true
		else
			return false
		end
	end
end