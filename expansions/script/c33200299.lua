--Dystopia罪名测试卡
function c33200299.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--test
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c33200299.op)
	c:RegisterEffect(e2)
end

function c33200299.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1-tp,33200300,nil,0,1)
	Duel.RegisterFlagEffect(1-tp,33200300,nil,0,1)
	Duel.RegisterFlagEffect(1-tp,33200300,nil,0,1)
	Duel.RegisterFlagEffect(tp,33200300,nil,0,1)
	Duel.RegisterFlagEffect(tp,33200300,nil,0,1)
	Duel.RegisterFlagEffect(tp,33200300,nil,0,1)
	local zz=Duel.GetFlagEffect(1-tp,33200300)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(33200300,zz))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(33200301,zz))
end