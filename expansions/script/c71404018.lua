--星忆泣寂
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	--①banish 星泣之凝忆 from deck or return 凝寂之星意 to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(yume.stellar_memories.HighSpellActivationTg(71404011,71404012))
	e1:SetOperation(yume.stellar_memories.HighSpellActivationOp(71404011,71404012,aux.Stringid(id,1),aux.Stringid(id,2)))
	c:RegisterEffect(e1)
	--②留空备用
	--③banished by 凝寂之星意: ritual summon with Link material from extra/field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+100000)
	e3:SetCondition(yume.stellar_memories.BanishedSpellCon(71404012))
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_DECK,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_DECK,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
