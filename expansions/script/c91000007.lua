--特殊怪兽
local m=91000007
local cm=c91000007
function c91000007.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))addsy
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,chk)
 local listsynchro={21123811,26268488,35952884,37442336,97489701,97836203,99585850,40939228,60465049,70980824,7841112,16172067,18969888,22850702,27572350,47710198,54082269,84815190,86682165,52687916,38354937,27315304,9753964,5041348,5772618,34408491,46815301,50954680,65187687,70771599}
 local listfusion={12381100,13331639,22723778,37542782,43228023,47172959,90050480,50855622,18666161,4628897,33652635,39552584,53315891} 
	local length = #listsynchro
	local ri = math.random(1,length)
	local tmp = table[1]
	listsynchro[1] = table[ri]
	listsy[ri] = tmp
	Duel.CreateToken(tp,n)
	
end
