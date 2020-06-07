--恶魔型异生兽 伽汝贝洛斯
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000039)
function cm.initial_effect(c)
	rssb.SummonCondition(c) 
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rssb.rmtdcost(3),rssb.sstg,rssb.ssop)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,1},{1,m+100},"sp,tk,neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(cm.filter),rssb.rmtdcost(1),cm.negtg,cm.negop)
end
function cm.filter(e,tp,re,rp,tg,loc)
	return loc&LOCATION_ONFIELD ~=0 and rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		for p=0,1 do 
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xaf4,0x4011,800,800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,p) then return false end
		end
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	for p=0,1 do 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xaf4,0x4011,800,800,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,p) then return end
	end
	for p=0,1 do 
		local token=Duel.CreateToken(tp,m+1)
		if Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE) then
			local e1=rsef.SV_CANNOT_BE_MATERIAL({e:GetHandler(),token,true},"link",nil,nil,rsreset.est_pend)
		end
	end
	Duel.SpecialSummonComplete()
end
