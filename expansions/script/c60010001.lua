--基督代理魔人
local cm,m,o=GetID()
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
cm.toss_dice=true
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,5 do
		local d1=0
		local d2=0
		while d1==d2 do
			d1,d2=Duel.TossDice(tp,1,1)
		end
		if d1<d2 then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		else
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end