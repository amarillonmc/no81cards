--调酒师 卢娜
local m=60001200
local cm=_G["c"..m]
cm.name="调酒师 卢娜"
sr_blackcode={60001202,60001203,60001204,60001205,60001206,60001207}
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoHand(tp)
	end
		Duel.SetChainLimit(aux.FALSE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local codes=sr_blackcode
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	local nb=Duel.TossDice(tp,1)
	local tk=Duel.CreateToken(tp,nb+60001201)
	Duel.Remove(tk,POS_FACEDOWN,0x20400)
	Duel.BreakEffect()
	tk:CompleteProcedure()
	Duel.SendtoHand(tk,nil,REASON_EFFECT)
end