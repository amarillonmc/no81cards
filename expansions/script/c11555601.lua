--档案员艾丽西娜
local s,id,o=GetID()
if not pcall(require,"expansions/script/c65199999") then pcall(require,"script/c65199999") end
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,1,8,s.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.Exile(g,REASON_EFFECT)
	local cg=Group.CreateGroup()
	local afilter={}
	for i=1,10 do
		afilter={zsx_CreateCode(),OPCODE_ISCODE}
		table.insert(afilter,zsx_CreateCode())
		table.insert(afilter,OPCODE_ISCODE)
		table.insert(afilter,OPCODE_OR)
		table.insert(afilter,zsx_CreateCode())
		table.insert(afilter,OPCODE_ISCODE)
		table.insert(afilter,OPCODE_OR)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local code=Duel.AnnounceCard(tp,table.unpack(afilter))
		afilter={}
		Duel.Hint(HINT_CARD,0,code)
		cg:AddCard(Duel.CreateToken(tp,code))
		cg:AddCard(Duel.CreateToken(tp,code))
	end
	Duel.SendtoDeck(cg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end