--火灵佑佐 希塔
local cm,m=GetID()
function cm.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e3)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	local e4=e2:Clone()
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op,loc,seq2,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_POSITION)
	if loc&LOCATION_SZONE~=0 and seq2>4 then return false end
	local seq1=aux.MZoneSequence(c:GetSequence())
	seq2=aux.MZoneSequence(seq2)
	return pos&POS_FACEUP>0 and bit.band(loc,LOCATION_ONFIELD)~=0 and (op==tp and seq1==seq2)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()|c:GetRank()|c:GetLink()
	local fg=c:GetColumnGroup()
	local dg=Duel.GetDecktopGroup(0,lv)+Duel.GetDecktopGroup(1,lv)
	if chk==0 then return #dg==lv*2 or #fg>0 end
	local lv=c:GetPreviousLevelOnField()|c:GetPreviousRankOnField()|c:GetLink()
	local fg=Duel.GetMatchingGroup(function(c) return aux.GetColumn(c,tp)==aux.MZoneSequence(c:GetPreviousSequence()) end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local dg=Duel.GetDecktopGroup(0,lv)+Duel.GetDecktopGroup(1,lv)
	e:SetLabel(lv,aux.MZoneSequence(c:GetPreviousSequence()))
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,fg+dg,#(fg+dg),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local lv,seq=e:GetLabel()
	local fg=Duel.GetMatchingGroup(function(c) return aux.GetColumn(c,tp)==seq end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local dg=Duel.GetDecktopGroup(0,lv)+Duel.GetDecktopGroup(1,lv)
	Duel.Destroy(fg+dg,REASON_EFFECT)
end